#!/usr/bin/python

import sys

if len(sys.argv) < 2: 
	print "Digitar quantos arquivos wav existem."
else:
	number_files = sys.argv[1]

file_mfcc = open("codetrain.scp", 'w')
file_mfcc_train = open("train.scp", 'w')

file_name = lambda x: "../train/wav/speaker_01/sample"+x+".wav ../train/mfcc/speaker_01/sample"+x+".mfc\n"
file_name_train = lambda x: "../train/mfcc/speaker_01/sample"+x+".mfc\n"

if number_files < 10:
	s_1 = [file_name("00"+str(i)) for i in xrange(1,number_files+1)]
	t_1 = [file_name_train("00"+str(i)) for i in xrange(1,number_files+1)]
	[file_mfcc.write(i) for i in s_1]
	[file_mfcc_train.write(i) for i in t_1]
elif number_files < 100:
	s_1 = [file_name("00"+str(i)) for i in xrange(1,10)]
	s_2 = [file_name("0"+str(i)) for i in xrange(10,number_files+1)]
	t_1 = [file_name_train("00"+str(i)) for i in xrange(1,10)]
	t_2 = [file_name_train("0"+str(i)) for i in xrange(10,number_files+1)]
	[file_mfcc.write(i) for i in s_1]
	[file_mfcc.write(i) for i in s_2]
	[file_mfcc_train.write(i) for i in t_1]
	[file_mfcc_train.write(i) for i in t_2]
elif number files >= 100:
	s_1 = [file_name("00"+str(i)) for i in xrange(1,10)]
	s_2 = [file_name("0"+str(i)) for i in xrange(10,100)]
	s_3 = [file_name(str(i)) for i in xrange(100,number_files+1)]
	t_1 = [file_name_train("00"+str(i)) for i in xrange(1,10)]
	t_2 = [file_name_train("0"+str(i)) for i in xrange(10,100)]
	t_3 = [file_name_train(str(i)) for i in xrange(100,number_files+1)]
	[file_mfcc.write(i) for i in s_1]
	[file_mfcc.write(i) for i in s_2]
	[file_mfcc.write(i) for i in s_3]
	[file_mfcc_train.write(i) for i in t_1]
	[file_mfcc_train.write(i) for i in t_2]
	[file_mfcc_train.write(i) for i in t_3]

file_mfcc.close()
file_mfcc_train.close()
