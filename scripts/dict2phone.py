import collections

# open files
file_dic = open("dict", 'w')
file_phones = open("monophones1", 'w')
file_phones_est = open("dlog", 'w')
file_report = open("report", 'w')
file_phones0 = open("monophones0", 'w')

# declare default data
phones = set()
phones_est = {}
words_and_phones = {}
words_alert = {}
alert=False
list_clara_lexicon= []
list_clara_dict=[]
missing_words=[]
total_words_wlist=0
total_words_clara_dict=0

# collet data from wlist (words collected from prompts.txt)
with open("wlist") as w:
	# list of all words in wlist
	[list_clara_lexicon.append(x.replace('\n','')) for x in w if x != '\n']

# lenght of total words of wlist
total_words_wlist=len(list_clara_lexicon)

# collet data from clara_lexicon (dict all words)
with open("clara_lexicon") as f:
	for line in f:
		line=line.replace('\t',' ').replace('\n','')
		line=line.replace('[','').replace(']','').split(' ')
		# dict of all words in dict and their phones
		words_and_phones[line[0]] = line[1:]
		if line[0] != "<s>" and line[0] != "</s>":
			words_and_phones[line[0]].append("sp")

		# loop to count occurence of each phone
		for x in words_and_phones[line[0]]:
			if x != '':
				phones.add(x)

				if x in phones_est:
					phones_est[x]+=1
				else:
					phones_est[x]=1

# organize dict file 
ord_wp = collections.OrderedDict(sorted(words_and_phones.items()))

# write data on dict file
for k,v in ord_wp.iteritems():
	if k != '':
		file_dic.write(k)
		for i in v:
			file_dic.write(' '+i+' ')
		file_dic.write('\n')

file_dic.close()

# collet data from dict (dict clara)
with open("dict") as w:
	for line in w:
		line=line.replace('\t',' ').replace('\n','')
		line=line.replace('[','').replace(']','').split(' ')
		# list of all words in wlist
		list_clara_dict.append(line[0])

# lenght of total words of dict
total_words_clara_dict=len(list_clara_dict)

# search for missing words
[missing_words.append(x) for x in list_clara_lexicon if x not in list_clara_dict]

# write data on phones file
for i in phones:
	file_phones.write(i+'\n')
	if i != "sp":
		file_phones0.write(i+'\n')

# write data on statistic file
file_phones_est.write("Phone Counts\n---------------------\n")
for k,v in phones_est.iteritems():
	if v<4:
		alert=True
		words_alert[k]=str(v)
	file_phones_est.write(k+' : '+str(v)+'\n')

# write data on report file
file_report.write("Dictionary Usage Statistics\n---------------------------\n")
file_report.write("Dictionary    TotalWords WordsUsed\n")
file_report.write("wlist   "+str(total_words_wlist)+' '+
		str(total_words_clara_dict)+'\n')
file_report.write(str(total_words_wlist)+" words required, "+
		str(len(missing_words))+" missing\n")

# alert if there are words in transcription file that is not present on dict
if len(missing_words)>0:
	file_report.write("\nWARNING: Missing the words:\n")
	[file_report.write(x+'\n') for x in missing_words]

# alert if there are phones with less than 4 occurences on dict file 
if alert:
	file_report.write("\nWARNING: Add words that use the following phones:\n")
	for k,v in words_alert.iteritems():
		file_report.write(k+' : '+v+'\n')

# close files
file_phones.close()
file_phones_est.close()
file_report.close()
file_phones0.close()

print "Done creating dict, monophones1, monophones0, dlog and report!"

