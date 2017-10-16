token=$(printenv TELEGRAM_TOKEN)
url=http://localhost:4000/telegram/$token

echo $url
test_update_payload_with_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}, \"text\": \"増加\"}}" -i $url && printf "\n\n"
}

test_update_payload_with_no_message() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234}" -i $url
}

test_update_payload_with_no_message_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}}}" -i $url
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
