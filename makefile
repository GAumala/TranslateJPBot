
JMdict_e.xml:
	wget ftp://ftp.monash.edu.au/pub/nihongo/JMdict_e.gz
	gunzip --stdout JMdict_e.gz > JMdict_e.xml

bash-test.sh:
	curl -L https://git.io/bash-test > bash-test.sh
	chmod u+x ./bash-test.sh

all: JMdict_e.xml bash-test

clean:
	rm JMdict_e.xml bash-test
