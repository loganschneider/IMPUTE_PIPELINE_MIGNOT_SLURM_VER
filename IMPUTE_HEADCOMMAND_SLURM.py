import re
import subprocess
import sys
with open('chr_sizes.txt') as chr_in:
	for line in chr_in:
		line_parse = line.strip().split('\t')
		chr_ = re.sub('chr', '', line_parse[0])
		size = line_parse[1]
		if len(line_parse[1]) < 9:
			makecommand = "./IMPUTE_LOOP_PHASE1_STEP3.sh "+chr_+' '+str(int(line_parse[1][:2])+1)+' '+sys.argv[1]+' '+sys.argv[2]
			subprocess.Popen(makecommand, shell=True)
		else:
			makecommand = "./IMPUTE_LOOP_PHASE1_STEP3.sh "+chr_+' '+str(int(line_parse[1][:3])+1)+' '+sys.argv[1]++' '+sys.argv[2]
			subprocess.Popen(makecommand, shell=True)
		print makecommand
