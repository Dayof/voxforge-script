file_mfcc = open("codetrain.scp", 'w')
file_mfcc_train = open("train.scp", 'w')

file_name = lambda x: "../train/wav/speaker_01/sample"+x+".wav ../train/mfcc/speaker_01/sample"+x+".mfc\n"

s1_9 = [file_name("00"+str(i)) for i in xrange(1,10)]
s10_65 = [file_name("0"+str(i)) for i in xrange(10,66)]

[file_mfcc.write(i) for i in s1_9]
[file_mfcc.write(i) for i in s10_65]

file_name_train = lambda x: "../train/mfcc/speaker_01/sample"+x+".mfc\n"

s1_9_train = [file_name_train("00"+str(i)) for i in xrange(1,10)]
s10_65_train = [file_name_train("0"+str(i)) for i in xrange(10,66)]

[file_mfcc_train.write(i) for i in s1_9_train]
[file_mfcc_train.write(i) for i in s10_65_train]

file_mfcc.close()
file_mfcc_train.close()
