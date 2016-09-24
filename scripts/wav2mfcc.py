#!/usr/bin/python

import sys

if len(sys.argv) < 2: 
	print "Digitar quantos arquivos wav existem."
else:
	number_files = sys.argv[1]
	number_files=int(number_files)

	file_mfcc = open("codetrain.scp", 'w')
	file_mfcc_train = open("train.scp", 'w')

	file_name = lambda x: "../train/wav/speaker_01/sample"+x+".wav ../train/mfcc/speaker_01/sample"+x+".mfc\n"
	file_name_train = lambda x: "../train/mfcc/speaker_01/sample"+str(x)+".mfc\n"
	
	to_str = lambda x,y : x + str(y)

	if number_files < 10:
		s_1 = [file_name(to_str("00",i)) for i in xrange(1,number_files+1)]
		t_1 = [file_name_train(to_str("00",i)) for i in xrange(1,number_files+1)]
		[file_mfcc.write(i) for i in s_1]
		[file_mfcc_train.write(i) for i in t_1]
	elif number_files < 100:
		s_1 = [file_name(to_str("00",i)) for i in xrange(1,10)]
		s_2 = [file_name(to_str("0",i)) for i in xrange(10,number_files+1)]
		t_1 = [file_name_train(to_str("00",i)) for i in xrange(1,10)]
		t_2 = [file_name_train(to_str("0",i)) for i in xrange(10,number_files+1)]
		[file_mfcc.write(i) for i in s_1]
		[file_mfcc.write(i) for i in s_2]
		[file_mfcc_train.write(i) for i in t_1]
		[file_mfcc_train.write(i) for i in t_2]
	elif number_files >= 100:
		s_1 = [file_name(to_str("00",i)) for i in xrange(1,10)]
		s_2 = [file_name(to_str("0",i)) for i in xrange(10,100)]
		s_3 = [file_name(to_str("",i)) for i in xrange(100,number_files+1)]
		t_1 = [file_name_train(to_str("00",i)) for i in xrange(1,10)]
		t_2 = [file_name_train(to_str("0",i)) for i in xrange(10,100)]
		t_3 = [file_name_train(to_str("",i)) for i in xrange(100,number_files+1)]
		[file_mfcc.write(i) for i in s_1]
		[file_mfcc.write(i) for i in s_2]
		[file_mfcc.write(i) for i in s_3]
		[file_mfcc_train.write(i) for i in t_1]
		[file_mfcc_train.write(i) for i in t_2]
		[file_mfcc_train.write(i) for i in t_3]

	file_mfcc.close()
	file_mfcc_train.close()
