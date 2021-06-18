yc compute instance create \
  --name reddit-full-vm \
  --zone ru-central1-a \
  --create-boot-disk name=disk1,size=15,image-id=fd8uvu4ge01f07f3vfsg \
  --public-ip \
  --ssh-key ~/.ssh/appuser.pub
