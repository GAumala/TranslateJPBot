
JMdict_e.xml:
	wget ftp://ftp.monash.edu.au/pub/nihongo/JMdict_e.gz
	gunzip --stdout JMdict_e.gz > JMdict_e.xml

all: JMdict_e.xml

clean:
	rm JMdict_e.xml
