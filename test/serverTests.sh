# These tests are meant to be run with `bash-test` like this: 
# $ TELEGRAM_TOKEN=<MY_SECRET_BOT_TOKEN> ./bash-test.sh test/serverTests.sh

# If you don't have the `bash-test` executable get it with `make bash-test.sh`

# You have to manually check that curl returns status code 200 in each of them
# You can then change the `host` variable to point to your VPS to make sure
# that it is setup correctly.

token=$(printenv TELEGRAM_TOKEN)
host=http://localhost:4000
url=$host/telegram/$token

echo $url
test_update_payload_with_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}, \"text\": \"増加\"}}" -i $url && printf "\n\n"
}

test_update_payload_with_no_message() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234}" -i $url && printf "\n\n"
}

test_update_payload_with_no_message_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}}}" -i $url && printf "\n\n"
}

test_telegram_example_message_with_text() {
  curl -v -k -X POST -H "Content-Type: application/json" -H "Cache-Control: no-cache"  -d '{
"update_id":10000,
"message":{
  "date":1441645532,
  "chat":{
     "last_name":"Test Lastname",
     "id":1111111,
     "type": "private",
     "first_name":"Test Firstname",
     "username":"Testusername"
  },
  "message_id":1365,
  "from":{
     "last_name":"Test Lastname",
     "id":1111111,
     "first_name":"Test Firstname",
     "username":"Testusername"
  },
  "text":"/start"
}
}' $url && printf "\n\n"
}
