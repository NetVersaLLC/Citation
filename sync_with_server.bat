cd C:\Users\jonathan\dev\Citation

scp -i C:\Users\jonathan\Dropbox\new_keys\deploy\contact -r labels ubuntu@ec2-23-22-146-4.compute-1.amazonaws.com:~/contact/shared/labels.new
ssh -i C:\Users\jonathan\Dropbox\new_keys\deploy\contact ubuntu@ec2-23-22-146-4.compute-1.amazonaws.com "rm -rf /home/ubuntu/contact/shared/labels.old && mv /home/ubuntu/contact/shared/labels /home/ubuntu/contact/shared/labels.old && mv /home/ubuntu/contact/shared/labels.new /home/ubuntu/contact/shared/labels"
