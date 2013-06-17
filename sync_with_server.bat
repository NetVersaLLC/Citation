cd C:\Users\jonathan\dev\Citation

scp -r labels deploy@franklin.netversa.com:~/contact/shared/labels.new
ssh deploy@franklin.netversa.com "rm -rf /home/deploy/contact/shared/labels.old && mv /home/deploy/contact/shared/labels /home/deploy/contact/shared/labels.old && mv /home/deploy/contact/shared/labels.new /home/deploy/contact/shared/labels"
