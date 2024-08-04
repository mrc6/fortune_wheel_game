local io = require('io')
local JSON = require('JSON')
local math = require('math')
local arrays = require('arrays')
local os = require('os')


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

main_loop = {
    loop = function(available_people_array_in,excluded_people_array_in)
            print("Choose the operation you want to perform")
            print("1 - Include someone into excluded people list")
            print("2 - Exclude someone into excluded people list")
            print("0 - Exit")
            print("")
            local choose = io.read()

            if choose == "1" then
                print("you chosse 1")
                print("Select the number of the person that you want to add into excluded people list")
                for i=1, #available_people_array do
                    print(i.." - "..available_people_array_in[i])
                end
                choose = io.read()
                people_selected = tonumber(choose)
        
                table.insert(excluded_people_array_in, available_people_array_in[people_selected])
                new_excluded_people_array = remove_duplicates_in_array.array(excluded_people_array_in)
    
                new_excluded_people_string = JSON:encode(new_excluded_people_array)
                string_to_json_file_overwrite.file('excluded_people.json', new_excluded_people_string)
    
                print(available_people_array_in[people_selected].. " add to excluded people list!")
                print("")
            elseif choose == "2" then
                print("you chosse 2")
                print("Select the number of the person that you want to exclude from excluded people list")
                for i=1, #available_people_array do
                    print(i.." - "..available_people_array_in[i])
                end
                choose = io.read()
                people_selected = tonumber(choose)
                
                people_selected_index = arrays.indexOf(excluded_people_array_in,available_people_array_in[people_selected])
                if people_selected_index == nil then
                  --do nothing
                else
                  table.remove(excluded_people_array_in, people_selected_index)
                end
                
                new_excluded_people_array = remove_duplicates_in_array.array(excluded_people_array_in)
    
                new_excluded_people_string = JSON:encode(new_excluded_people_array)
                string_to_json_file_overwrite.file('excluded_people.json', new_excluded_people_string)
    
                print(available_people_array_in[people_selected].. " excluded from excluded people list!")
                print("")
            else
                print("Bye")
                return "n"
            end
            print("Do you want to perform another operation? <y/n>")
            choose = io.read()
        return choose
    end
}


--reading json file
available_people_string = json_file_to_string.file('available_people.json')
excluded_people_string = json_file_to_string.file('excluded_people.json')

--decoding json string
available_people_array = JSON:decode(available_people_string)
excluded_people_array = JSON:decode(excluded_people_string)

print("Welcome back to the 1980s")
print("")
print("This is the Fortune Weel Administration!!!")

continue_program = "y"

while continue_program == "y" do
    continue_program = main_loop.loop(available_people_array,excluded_people_array)
    --continue_program = io.read() 
end

