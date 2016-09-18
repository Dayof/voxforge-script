# open file
file_mono0 = open("monophones0", 'w')

mono1=[]

# collet data from monophones1
with open("monophones1") as w:
	# list of all words in monophones1
	[mono1.append(x.replace('\n','')) for x in w if x != '\n' and x != "sp\n"]

# write data on monophones0 file
for i in mono1:
	file_mono0.write(i+'\n')

# close file
file_mono0.close()
