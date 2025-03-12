gcloud compute instances create ml-machine \
    --project=airy-phalanx-453511-f0 \
    --zone=us-west4-b \
    --machine-type=n1-standard-4 \
    --network-interface=network-tier=STANDARD,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE,startup-script-url=https://raw.githubusercontent.com/jeffangel/ml2f/refs/heads/main/startup.sh \
    --maintenance-policy=TERMINATE \
    --provisioning-model=STANDARD \
    --service-account=995622741291-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,\
https://www.googleapis.com/auth/logging.write,\
https://www.googleapis.com/auth/monitoring.write,\
https://www.googleapis.com/auth/service.management.readonly,\
https://www.googleapis.com/auth/servicecontrol,\
https://www.googleapis.com/auth/trace.append \
    --accelerator=count=1,type=nvidia-tesla-t4 \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-20250312-005141,\
image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20250305,\
mode=rw,size=50,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

# Crear configuración para Ops Agent
printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml

# Aplicar la política de Ops Agent a la instancia
gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-us-west4-b \
    --project=airy-phalanx-453511-f0 \
    --zone=us-west4-b \
    --file=config.yaml
