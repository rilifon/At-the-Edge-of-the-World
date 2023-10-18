extends Node

const ENDING_1_PATH = "res://assets/audio/narration/end_1/"
const ENDING_2_PATH = "res://assets/audio/narration/end_2/"
const ENDING_1_FINAL_NARRATION = preload("res://assets/audio/narration/end_1/FinalNarration.wav")
const ENDING_2_FINAL_NARRATION = preload("res://assets/audio/narration/end_2/FinalNarration.wav")
const ENDING_1 = [
	{"cha": "ahab", "text": "END1_1", "voice": "01.wav", "delay": .9},
	{"cha": "yog", "text": "END1_2", "voice": "02.wav"},
	{"cha": "yog", "text": "END1_3", "voice": "03.wav","dist_delay": -0.3},
	{"cha": "ahab", "text": "END1_4", "voice": "04.wav", "delay": .5},
	{"cha": "yog", "text": "END1_5", "voice": "05.wav","dist_delay": 0.6},
	{"cha": "ahab", "text": "END1_6", "voice": "06.wav"},
	{"cha": "yog", "text": "END1_7", "voice": "07.wav"},
]
const ENDING_2_1 = [
	{"cha": "ahab", "text": "END2_1", "voice": "01.wav", "delay": 1.0},
	{"cha": "yog", "text": "END2_2", "voice": "02.wav"},
	{"cha": "yog", "text": "END2_3", "voice": "03.wav","dist_delay": -0.3},
	{"cha": "ahab", "text": "END2_4", "voice": "04.wav", "delay": .6},
	{"cha": "yog", "text": "END2_5", "voice": "05.wav","dist_delay": 0.6},
]
const ENDING_2_2 = [
	{"cha": "yog", "text": "END2_6", "voice": "06.wav"},
	{"cha": "ahab", "text": "END2_7", "voice": "07.wav"},
	{"cha": "yog", "text": "END2_8", "voice": "08.wav"},
	{"cha": "ahab", "text": "END2_9", "voice": "09.wav"},
]
const DB = [
	#Level 0
	[	
		#Dialogue 1
		[
			{"cha": "ahab", "text": "D1_1", "voice": "01/01.wav"},
			{"cha": "yog", "text": "D1_2", "voice": "01/02.wav", "dist_delay": -0.3},
			{"cha": "ahab", "text": "D1_3", "voice": "01/03.wav"},
		],
		#Dialogue 2
		[
			{"cha": "ahab", "text": "D2_1", "voice": "02/01.wav"},
		],
		#Dialogue 3
		[
			{"cha": "yog", "text": "D3_1", "voice": "03/01.wav"},
			{"cha": "ahab", "text": "D3_2", "voice": "03/02.wav"},
		],
		#Dialogue 4
		[
			{"cha": "ahab", "text": "D4_1", "voice": "04/01.wav"},
			{"cha": "yog", "text": "D4_2", "voice": "04/02.wav"},
			{"cha": "ahab", "text": "D4_3", "voice": "04/03.wav"},
		],
		#Dialogue 5
		[
			{"cha": "ahab", "text": "D5_1", "voice": "05/01.wav"},
			{"cha": "yog", "text": "D5_2", "voice": "05/02.wav"},
			{"cha": "ahab", "text": "D5_3", "voice": "05/03.wav"},
		],
		#Dialogue 6
		[
			{"cha": "ahab", "text": "D6_1", "voice": "06/01.wav"},
			{"cha": "yog", "text": "D6_2", "voice": "06/02.wav", "dist_delay": 0.8},
			{"cha": "ahab", "text": "D6_3", "voice": "06/03.wav"},
		],
	],
	#Level 1
	[
		#Dialogue 7
		[
			{"cha": "ahab", "text": "D7_1", "voice": "07/01.wav"},
			{"cha": "ahab", "text": "D7_2", "voice": "07/02.wav"},
		],
		#Dialogue 8
		[
			{"cha": "ahab", "text": "D8_1", "voice": "08/01.wav"},
			{"cha": "ahab", "text": "D8_2", "voice": "08/02.wav"},
		],
		#Dialogue 9
		[
			{"cha": "ahab", "text": "D9_1", "voice": "09/01.wav"},
			{"cha": "ahab", "text": "D9_2", "voice": "09/02.wav"},
		],
		#Dialogue 10
		[
			{"cha": "ahab", "text": "D10_1", "voice": "10/01.wav"},
			{"cha": "yog", "text": "D10_2", "voice": "10/02.wav"},
			{"cha": "ahab", "text": "D10_3", "voice": "10/03.wav"},
			{"cha": "yog", "text": "D10_4", "voice": "10/04.wav"},
			{"cha": "ahab", "text": "D10_5", "voice": "10/05.wav"},
		],
		#Dialogue 11
		[
			{"cha": "ahab", "text": "D11_1", "voice": "11/01.wav"},
			{"cha": "yog", "text": "D11_2", "voice": "11/02.wav"},
			{"cha": "ahab", "text": "D11_3", "voice": "11/03.wav"},
		],
		#Dialogue 12
		[
			{"cha": "ahab", "text": "D12_1", "voice": "12/01.wav"},
			{"cha": "ahab", "text": "D12_2", "voice": "12/02.wav"},
		],
	],
	#Level 2
	[
		#Dialogue 13
		[
			{"cha": "ahab", "text": "D13_1", "voice": "13/01.wav"},
			{"cha": "yog", "text": "D13_2", "voice": "13/02.wav"},
			{"cha": "ahab", "text": "D13_3", "voice": "13/03.wav"},
		],
		#Dialogue 14
		[
			{"cha": "ahab", "text": "D14_1", "voice": "14/01.wav"},
			{"cha": "yog", "text": "D14_2", "voice": "14/02.wav"},
			{"cha": "yog", "text": "D14_3", "voice": "14/03.wav", "dist_delay": 0.5},
			{"cha": "ahab", "text": "D14_4", "voice": "14/04.wav"},
		],
		#Dialogue 15
		[
			{"cha": "ahab", "text": "D15_1", "voice": "15/01.wav"},
			{"cha": "ahab", "text": "D15_2", "voice": "15/02.wav"},
			{"cha": "yog", "text": "D15_3", "voice": "15/03.wav"},
		],
		#Dialogue 16
		[
			{"cha": "ahab", "text": "D16_1", "voice": "16/01.wav"},
			{"cha": "yog", "text": "D16_2", "voice": "16/02.wav", "dist_delay": 0.8},
			{"cha": "ahab", "text": "D16_3", "voice": "16/03.wav"},
		],
		#Dialogue 17
		[
			{"cha": "ahab", "text": "D17_1", "voice": "17/01.wav"},
			{"cha": "ahab", "text": "D17_2", "voice": "17/02.wav"},
			{"cha": "ahab", "text": "D17_3", "voice": "17/03.wav"},
		],
		#Dialogue 18
		[
			{"cha": "ahab", "text": "D18_1", "voice": "18/01.wav"},
			{"cha": "ahab", "text": "D18_2", "voice": "18/02.wav"},
		],
	],
	#Level 3
	[
		#Dialogue 19
		[
			{"cha": "ahab", "text": "D19_1", "voice": "19/01.wav"},
			{"cha": "yog", "text": "D19_2", "voice": "19/02.wav"},
			{"cha": "yog", "text": "D19_3", "voice": "19/03.wav", "dist_delay": -0.8},
			{"cha": "ahab", "text": "D19_4", "voice": "19/04.wav"},
		],
		#Dialogue 20
		[
			{"cha": "yog", "text": "D20_1", "voice": "20/01.wav"},
			{"cha": "ahab", "text": "D20_2", "voice": "20/02.wav"},
			{"cha": "yog", "text": "D20_3", "voice": "20/03.wav"},
		],
		#Dialogue 21
		[
			{"cha": "yog", "text": "D21_1", "voice": "21/01.wav"},
			{"cha": "ahab", "text": "D21_2", "voice": "21/02.wav"},
		],
		#Dialogue 22
		[
			{"cha": "ahab", "text": "D22_1", "voice": "22/01.wav"},
			{"cha": "yog", "text": "D22_2", "voice": "22/02.wav"},
			{"cha": "ahab", "text": "D22_3", "voice": "22/03.wav"},
		],
		#Dialogue 23
		[
			{"cha": "yog", "text": "D23_1", "voice": "23/01.wav"},
			{"cha": "yog", "text": "D23_2", "voice": "23/02.wav"},
			{"cha": "yog", "text": "D23_3", "voice": "23/03.wav"},
			{"cha": "ahab", "text": "D23_4", "voice": "23/04.wav"},
		],
		#Dialogue 24
		[
			{"cha": "yog", "text": "D24_1", "voice": "24/01.wav", "dist_delay": 0.2},
			{"cha": "ahab", "text": "D24_2", "voice": "24/02.wav"},
			{"cha": "yog", "text": "D24_3", "voice": "24/03.wav", "dist_delay": 0.2},
			{"cha": "ahab", "text": "D24_4", "voice": "24/04.wav"},
			{"cha": "yog", "text": "D24_5", "voice": "24/05.wav"},
			{"cha": "ahab", "text": "D24_6", "voice": "24/06.wav"},
		],
	],
	#Level 4
	[
		#Dialogue 25
		[
			{"cha": "yog", "text": "D25_1", "voice": "25/01.wav", "dist_delay": 0.2},
			{"cha": "ahab", "text": "D25_2", "voice": "25/02.wav"},
			{"cha": "yog", "text": "D25_3", "voice": "25/03.wav"},
			{"cha": "ahab", "text": "D25_4", "voice": "25/04.wav"},
		],
		#Dialogue 26
		[
			{"cha": "ahab", "text": "D26_1", "voice": "26/01.wav"},
			{"cha": "ahab", "text": "D26_2", "voice": "26/02.wav"},
		],
		#Dialogue 27
		[
			{"cha": "ahab", "text": "D27_1", "voice": "27/01.wav"},
			{"cha": "ahab", "text": "D27_2", "voice": "27/02.wav"},
		],
		#Dialogue 28
		[
			{"cha": "ahab", "text": "D28_1", "voice": "28/01.wav"},
			{"cha": "ahab", "text": "D28_2", "voice": "28/02.wav"},
			{"cha": "yog", "text": "D28_3", "voice": "28/03.wav"},
			{"cha": "ahab", "text": "D28_4", "voice": "28/04.wav"},
		],
		#Dialogue 29
		[
			{"cha": "ahab", "text": "D29_1", "voice": "29/01.wav"},
			{"cha": "yog", "text": "D29_2", "voice": "29/02.wav"},
			{"cha": "yog", "text": "D29_3", "voice": "29/03.wav", "dist_delay": 0.2},
			{"cha": "ahab", "text": "D29_4", "voice": "29/04.wav"},
		],
		#Dialogue 30
		[
			{"cha": "ahab", "text": "D30_1", "voice": "30/01.wav"},
			{"cha": "yog", "text": "D30_2", "voice": "30/02.wav", "dist_delay": 0.3},
			{"cha": "ahab", "text": "D30_3", "voice": "30/03.wav"},
		],
		#Dialogue 31
		[
			{"cha": "ahab", "text": "D31_1", "voice": "31/01.wav"},
			{"cha": "yog", "text": "D31_2", "voice": "31/02.wav"},
			{"cha": "ahab", "text": "D31_3", "voice": "31/03.wav"},
			{"cha": "yog", "text": "D31_4", "voice": "31/04.wav"},
		],
		#Dialogue 32
		[
			{"cha": "ahab", "text": "D32_1", "voice": "32/01.wav"},
			{"cha": "yog", "text": "D32_2", "voice": "32/02.wav"},
			{"cha": "yog", "text": "D32_3", "voice": "32/03.wav"},
			{"cha": "yog", "text": "D32_4", "voice": "32/04.wav"},
			{"cha": "ahab", "text": "D32_5", "voice": "32/05.wav"},
		],
	],
]
