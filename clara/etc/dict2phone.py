file_phones = open("clara.phone", 'w')

phones = set()

with open("clara.dic") as f:
	for line in f:
		line=line.replace('\t',' ').replace('\n','').split(' ')
		[phones.add(x) for x in line[1:] if x != '']

for i in phones:
	file_phones.write(i+'\n')

file_phones.write("SIL\n")

file_phones.close()
