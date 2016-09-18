file_macros = open("macros", 'w')

list_vfloors = []

# collet data from vFloors 
with open("vFloors") as w:
	[list_vfloors.append(x.replace('\n','')) for x in w if x != '\n']

file_proto = open("proto")
lines_proto = ""
l_lines_proto = []

for i, line in enumerate(file_proto):
	lines_proto+=line	
	if i>1: 
		break

l_lines_proto=lines_proto.split("\n")

for y in l_lines_proto[:-1]:
	file_macros.write(y+'\n')

for x in list_vfloors:
	file_macros.write(x+'\n')

file_macros.write('\n')

file_proto.close()
file_macros.close()
