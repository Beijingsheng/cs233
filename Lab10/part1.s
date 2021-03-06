# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

PLANT_SCAN	= 0xffff0050

CLOUD_SCAN		= 0xffff0054
CLOUD_STATUS_INFO	= 0xffff00c0

GET_WATER	= 0xffff00c8
WATER_VALVE	= 0xffff00c4

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

CLOUD_CHANGE_STATUS_ACK		= 0xffff0064
CLOUD_CHANGE_STATUS_INT_MASK	= 0x2000

OUT_OF_WATER_ACK	= 0xffff0068
OUT_OF_WATER_INT_MASK	= 0x4000

.data
# put your data things here
.align 2
plant_data: .space 88

.text
main:
	# put your code here :)
	la		$t0, plant_data	#
	sw		$t0, PLANT_SCAN	#

	lw		$t1, 4($t0)		# load plant 0 x loc
	lw		$t2, BOT_X		# load spimbot x loc


angle_setting:
	sub 	$t3, $t2, $t1	# $t3 will be 1 if bot is right of plant0

	li		$t9, 1			#
	sw		$t9, ANGLE_CONTROL	# set angle to absolute

	bne		$t3, 0, water_b____es	# if  ==  then
	sw		$t9, WATER_VALVE#  =

water_b____es:

	bgt		$t3, 0, ebola	#
	li		$t8, 0			#
	sw		$t8, ANGLE		#
	j		velocity_setting# jump to velocity_setting

ebola:
	li		$t8, 180		#
	sw		$t8, ANGLE		#

velocity_setting:
	li		$t7, 10			#  =

	sw		$t7, VELOCITY	#

end:

	# note that we infinite loop to avoid stopping the simulation early
	j	main
