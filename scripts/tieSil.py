file_sil_hmm = open("sil_hmm.txt")
file_hmm4 = open("hmmdefs",'a')

lines_sil_hmm = ""
l_lines_sil_hmm = []
temp_line=""
ignore_lines=False

for i, line in enumerate(file_sil_hmm):
	if line=="<STATE> 2\n" or line=="<STATE> 4\n":
		ignore_lines=True
		continue
	elif line=="<STATE> 3\n":
		ignore_lines=False
		temp_line="<STATE> 2\n"
		lines_sil_hmm+=temp_line
		continue
	elif line=="<TRANSP> 5\n":
		lines_sil_hmm+="<TRANSP> 3\n0.0 1.0 0.0\n0.0 0.9 0.1\n0.0 0.0 0.0\n<ENDHMM>\n"
		break

	if i==2:
		temp_line="<NUMSTATES> 3\n"
	elif not ignore_lines:
		temp_line=line
	else:
		continue

	lines_sil_hmm+=temp_line

l_lines_sil_hmm=lines_sil_hmm.split("\n")

for i in l_lines_sil_hmm:
	file_hmm4.write(i+'\n')

file_sil_hmm.close()
file_hmm4.close()
