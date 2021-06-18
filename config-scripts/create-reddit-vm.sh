yc compute instance create \
  --name reddit-full-vm \
  --zone ru-central1-a \
  --create-boot-disk name=disk1,size=15,image-id=fd892l6aqsdcg3m833t2 \
  --public-ip \
  --ssh-key ~/.ssh/appuser.pub
