# Translate JP Bot

Chat bot that translates Japanese words into English using [JMdict](http://edrdg.org/jmdict/j_jmdict.html).

You can talk to the bot right now with [Telegram](https://telegram.org/) The bot's handle is @TranslateJPBot. The bot will try to translate any text that you send to it.

![screenshot](https://user-images.githubusercontent.com/5729175/31618760-70f4b0c8-b258-11e7-86d3-25b3623d1024.jpeg)

## How it works

The bot parses the Jmdict XML file and inserts each word, in both hiragana and kanji forms, into a Red Black Tree. Because of this, finding a word is a O(log(n)) operation. Once the tree is ready it spins up a [Scotty](https://github.com/scotty-web/scotty) server exposing a single endpoint for the telegram Webhook. When telegram posts an update, it tries to reply with a translation.

## Limitations

There's still a lot of room for improvement. Here's a list of current limitations that I want to change in the future.

- Telegram is the only platform supported. Eventually it should support other popular chat apps like Facebook or Discord.
- The bot can't translate sentences, let alone verb/adjective conjugations. The bot lacks an algorithm to map conjugated forms to dictionary entry forms, as well as an algorithm to identify each word in a sentence. Right now it only works if you pass the word exactly as it is on a dictionary.
- The bot is memory intensive. Since it loads the whole Japanese dictionary into a binary tree in memory, it uses about 2 GB of RAM when running.


## Build

Clone with git and build with cmake and Stack
``` bash
git clone https://github.com/GAumala/TranslateJPBot
make
stack setup
stack build
```

Run the server with:

``` bash
TELEGRAM_TOKEN=<MY_SECRET_TOKEN> stack exec bot
```

## Deploy

If you already have an nginx server setup with SSL, you can easily deploy the bot by adding a new `location` to your existing `server` block. 

``` diff
# /etc/nginx/nginx.conf

server {
 
               # Existing configuration...

+               location ^~ /path/to/bot/ {
+                       proxy_pass http://localhost:4000;
+               }
        }
```

After that, you need to register a webhook to the Telegram API. It is encouraged to use the secret token as part of the webhook URL to avoid malicious attackers to try to talk to your bot. To register the url just use `curl`

``` bash
curl -F “url=https://<YOURDOMAIN.EXAMPLE>/path/to/bot/<MY_SECRET_TOKEN>" https://api.telegram.org/bot<MY_SECRET_TOKEN>/setWebhook
```

That's it! You're done! If you want to test that the server is running correctly you can modify `test/serverTests.sh` to point to your server and run the tests.

``` diff
token=$(printenv TELEGRAM_TOKEN)
-host=http://localhost:4000
+host=https://<YOURDOMAIN.EXAMPLE>/path/to/bot
url=$host/$token
```

If you see status 200 on each request, then the bot is running correctly.



