# Translate JP Bot

Chat bot that translates Japanese words into English using JMdict.

You can talk to the bot right now with Telegram[https://telegram.org/] The bot's handle is @TranslateJPBot. The bot will try to translate any text that you send to it.

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
