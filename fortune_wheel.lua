local io = require('io')
local JSON = require('JSON')
local math = require('math')
local arrays = require('arrays')
local os = require('os')


print("Welcome back to the 1980s")
print("")
print("This is the Fortune wheel!!!")

--functions
json_file_to_string = {
    file = function(file_name)
                openning_file = io.open(file_name, 'r')
                file_string = openning_file:read()
                openning_file:close()
                return file_string
           end
}

string_to_json_file_overwrite = {
    file = function(file_name, string_to_write)
                openning_file = io.open(file_name, 'w')
                file_string = openning_file:write(string_to_write)
                openning_file:flush()
                openning_file:close()
                return nil
           end
}

remove_duplicates_in_array = {
array = function(remove_from)
    local hash = {}
    local res = {}
    for _,v in ipairs(remove_from) do
       if (not hash[v]) then
           res[#res+1] = v -- you could print here instead of saving to result table if you wanted
           hash[v] = true
       end
    end
    return res
end
}

get_available_people = {
    available_people = function(avaliable_array, excluded_array, winners_array)
                           excluded_indexes = {}
                           if #excluded_array == 0 then
                               --do nothing
                           else
                               for excluded_person = 1, #excluded_array do
                                   excluded_index = arrays.indexOf(avaliable_array, excluded_array[excluded_person])
                                   if excluded_index == nil then
                                       --do nothing
                                   else
                                       table.insert(excluded_indexes,excluded_index)
                                   end
                               end
                           end                           
                           if #winners_array == 0 then
                               --do nothing
                           else
                               for excluded_person = 1, #winners_array do
                                   excluded_index = arrays.indexOf(avaliable_array, winners_array[excluded_person])
                                   if excluded_index == nil then
                                       --do nothing
                                   else
                                       table.insert(excluded_indexes,excluded_index)
                                   end
                               end
                           end

                           --formating the indexes array
                           excluded_indexes_no_duplicates = remove_duplicates_in_array.array(excluded_indexes)
                           table.sort(excluded_indexes_no_duplicates)
                           
                           if #excluded_indexes == 0 then
                               --do nothing
                           else
                               for remove_person = #excluded_indexes_no_duplicates,1,-1 do
                                 table.remove(avaliable_array,excluded_indexes_no_duplicates[remove_person])
                               end
                           end 
                           return avaliable_array
                       end
}

oh_wait = {
    seconds = function(s)
        local start = os.time()
        repeat until os.time() > start + s
    end
}

--reading json file
available_people_string = json_file_to_string.file('available_people.json')
excluded_people_string = json_file_to_string.file('excluded_people.json')
winners_people_string = json_file_to_string.file('winners_people.json')

--decoding json string
available_people_array = JSON:decode(available_people_string)
excluded_people_array = JSON:decode(excluded_people_string)
winners_people_array = JSON:decode(winners_people_string)

people_on_the_game_array = get_available_people.available_people(available_people_array,excluded_people_array,winners_people_array)

--look if there are someone to get
if #people_on_the_game_array == 0 then
    print("All people was selected, refreshing the list")
    available_people_array = JSON:decode(available_people_string)
    winners_people_array = JSON:decode("[]")
    people_on_the_game_array = get_available_people.available_people(available_people_array,excluded_people_array,winners_people_array)
end

if arg[1] == '-l' then
    print("listing available people to win")
    for i=1, #people_on_the_game_array do
        print(i.." - "..people_on_the_game_array[i])
    end
    os.exit()
end

print("Insert Coin ... or simple press ENTER")
local name = io.read()

print("Are you ready to spin the wheel?")
print("Press ENTER to spin the wheel")
name = io.read()

--spinning the wheel
math.randomseed(os.time())
turns = math.random(10,15)
print("Spinning the wheel...it will take some seconds")
for i=1,turns  do
  oh_wait.seconds(1)
end

--getting the winner
winner = people_on_the_game_array[ math.random( #people_on_the_game_array ) ]
print("")
print("The winner is: "..winner.."! Congratulations!!!")

--saving table to json file
table.insert(winners_people_array, winner)
new_available_people_string = JSON:encode(winners_people_array)
string_to_json_file_overwrite.file('winners_people.json', new_available_people_string)
