# day 2 

def parse_game_line(game_line):
    #Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    game_num = int(game_line.split(":")[0].split(" ")[1])
    sets = game_line.split(":")[1].split(";")
    game_counts = {}
    for i, set in enumerate(sets):
        set_colors = {"red":0, "green":0, "blue":0}
        cube_colors = set.split(",")
        for cube in cube_colors:
            if cube:
                num, color = cube.strip().split(" ")
                set_colors[color] = int(num)
        # missing = {"red", "green", "blue"}-set_colors.keys()
        # if missing:
        #     set_colors[missing] = 0
        game_counts[i] = set_colors

        # if set.find("red") == -1:
        #     red_num = 0
        # else:
        #     red_num = int(set[set.find("red")-2])
        # if set.find("green") == -1:
        #     green_num = 0
        # else:
        #     green_num = int(set[set.find("green")-2])
        # if set.find("blue") == -1:
        #     blue_num = 0
        # else:
        #     blue_num = int(set[set.find("blue")-2])
        # game_counts[i] = {"red": red_num, "green": green_num, "blue": blue_num}
    return game_num, game_counts

def find_max(game_counts, totals={"red": 12, "green": 13, "blue": 14}):
    possible = True
    for set_num, cubes_count in game_counts.items():
        for color, count in cubes_count.items():
            if count > totals[color]:
                possible = False
    return possible

def check_possible(game_line):
    game_num, game_counts = parse_game_line(game_line)
    possible = find_max(game_counts)
    if possible:
        return game_num
    else:
        return 0

open_file = open("assets/cube_game.txt", "r")
game_lines = open_file.readlines()
sum = 0
for line in game_lines:
    # print(check_possible(line))
    sum += check_possible(line)
print(sum)


# part 2

def find_max2(game_counts):
    max = {"red": 0, "green": 0, "blue": 0}
    for set_num, cubes_count in game_counts.items():
        for color, count in cubes_count.items():
            if count > max[color]:
                max[color] = count
    return max

open_file = open("assets/cube_game.txt", "r")
game_lines = open_file.readlines()
sum = 0
for line in game_lines:
    game_num, game_counts = parse_game_line(line)
    max = find_max2(game_counts)
    power = 1
    for value in max.values():
        power *= value
    sum += power
print(sum)

