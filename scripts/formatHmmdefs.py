quotes = lambda x: '~h "'+x+'"\n'
list_hmm = []

# collet data from hmmdefs 
with open("hmmdefs") as w:
	# list of all phones in hmmdefs
	[list_hmm.append(x.replace('\n','')) for x in w if x != '\n']

list_hmm_formated=map(quotes,list_hmm)

file_proto = open("proto")
lines_proto = ""
l_lines_proto = []

for i, line in enumerate(file_proto):
    if i>=4:
	lines_proto+=line

l_lines_proto=lines_proto.split("\n")

file_proto.close()

file_new_hmmdefs = open("hmmdefs", 'w')

for x in list_hmm_formated:	
	file_new_hmmdefs.write(x)
	for y in l_lines_proto[:-1]:
		file_new_hmmdefs.write(y+'\n')

file_new_hmmdefs.write('\n')
file_new_hmmdefs.close()
