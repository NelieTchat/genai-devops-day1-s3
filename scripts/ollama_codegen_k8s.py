#!/usr/bin/env python3
import subprocess, sys, pathlib, textwrap

PROMPT = textwrap.dedent("""\
You are a Kubernetes YAML author. Output EXACTLY two YAML documents and nothing else.
No commentary. No backticks. No extra lines before/after.

Constraints:
- Deployment (apps/v1) named demo-web, replicas=2
- Container image: ghcr.io/OWNER/IMAGE:TAG
- Labels on pod & service: app=demo, tier=web
- Resources: requests {cpu: 50m, memory: 64Mi}, limits {cpu: 250m, memory: 256Mi}
- Probes: readiness & liveness HTTP GET /healthz on port 8080
- envFrom: configMapRef name=demo-config
- securityContext: runAsNonRoot=true, readOnlyRootFilesystem=true, drop ALL
- Service: ClusterIP demo-web on port 80 -> targetPort 8080

Output format:
<YAML for Deployment>
---
<YAML for Service>
""")

def run_ollama(model: str, prompt: str) -> str:
    proc = subprocess.run(["ollama", "run", model], input=prompt.encode("utf-8"),
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc.returncode != 0:
        sys.stderr.write(proc.stderr.decode("utf-8"))
        sys.exit(proc.returncode)
    return proc.stdout.decode("utf-8").strip()

def main():
    model = sys.argv[1] if len(sys.argv) > 1 else "mistral"
    out_path = pathlib.Path("k8s_generated.yaml")
    yaml_out = run_ollama(model, PROMPT)

    # minimal sanity checks
    if "---" not in yaml_out or "apiVersion" not in yaml_out:
        sys.stderr.write("Model output did not look like two YAML docs.\n")
        sys.exit(2)

    out_path.write_text(yaml_out + "\n", encoding="utf-8")
    print(f"[WRITE] {out_path} ({len(yaml_out.splitlines())} lines)")

if __name__ == "__main__":
    main()
