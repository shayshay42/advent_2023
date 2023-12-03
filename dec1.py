#calibration codes of the trebuchet

#solving the example

# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet

#assume stored as strings in a list

cal_vals = ['1abc2', 'pqr3stu8vwx', 'a1b2c3d4e5f', 'treb7uchet']

#open the file in assets/calibration.txt and read line by line as string
with open('assets/calibration_values.txt', 'r') as file:
    cal_vals = file.readlines()

#extract all digits with regex
import re

def get_sum(cal_vals):
    sum = 0
    for val in cal_vals:
        digits = re.findall(r'\d', val)
        if len(digits) == 0:
            continue
        number = int(digits[0] + digits[-1])
        # print(number)
        sum += number
    return sum
#part 2

#example
cal_vals2 = ['two1nine', 'eightwothree', 'abcone2threexyz', 'xtwone3four', '4nineeightseven2', 'zoneight234', '7pqrstsixteen']

# def replace_letters(word, spelled = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]):
#     #find if subset of word contains any of spelled and replace it with the digit
#     for i in range(len(word)):
#         for j in range(i+1, len(word)+1):
#             if word[i:j] in spelled:
#                 word = word.replace(word[i:j], str(spelled.index(word[i:j])))
#     return word

# Revised function for Part Two
# def replace_letters(val):
#     spelled = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
#     for index, word in enumerate(spelled):
#         val = val.replace(word, str(index+1))
#     return val

# def replace_letters(val):
#     spelled = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]#not including zero
#     result = ""
#     i = 0
#     while i < len(val):
#         #add to result if its a digit
#         print("Result is ", result)
#         try :
#             dig = int(val[i])
#             result += str(dig)
#             print(dig)
#             i += 1
#             continue
#         except ValueError:
#             for number in spelled:
#                 if val[i:i+len(number)] == number:
#                     print(number)
#                     result += str(spelled.index(number)+1)
#                     i += 1#len(number)
#                     continue
#     return result

# def replace_letters(val):
#     spelled = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]  # not including zero
#     result = ""
#     i = 0
#     while i < len(val):
#         if val[i].isdigit():
#             # If it's a digit, add to result
#             result += val[i]
#             i += 1
#         else:
#             # Check for spelled-out numbers
#             replaced = False
#             for number in spelled:
#                 if val[i:i+len(number)] == number:
#                     result += str(spelled.index(number) + 1)
#                     i += 1
#                     continue
#             if not replaced:
#                 # Increment i if no match was found
#                 i += 1
#     return result

def replace_letters(val):
    spelled = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]  # not including zero
    result = ""
    i = 0
    while i < len(val):
        if val[i].isdigit():
            # If it's a digit, add to result
            result += val[i]
            i += 1
        else:
            # Check for spelled-out numbers
            for number in spelled:
                if val[i:i+len(number)] == number:
                    result += str(spelled.index(number) + 1)
                    break
            # Always increment i by 1 to avoid missing overlaps
            i += 1
    return result


replace_letters("eightwone3four")

def get_sum2(cal_vals):
    sum = 0
    for val in cal_vals:
        val = replace_letters(val)
        digits = re.findall(r'\d', val)
        if len(digits) == 0:
            continue
        number = int(digits[0] + digits[-1])
        print(number)
        # print(number)
        sum += number
    return sum

print(get_sum2(cal_vals))
