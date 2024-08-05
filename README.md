# fortune_weel_game

![image](https://github.com/user-attachments/assets/cfc63957-c781-407c-8183-efd6f0d84d21)


This is the fortune weel game. You spin the weel and the name of the winner is selected

What you need?

The only thing that you need is overwrite the available_people.json file with the name of your friends.
Every time you spin the weel one person is selected. So the selected people is remove from the list of the availiable people for other turns.

Once everyone is selected, the available people list is refreshed.

You also may include someone excluded from the game, for instance, in case the person is not present. In this case you need to use the admin_fortune_weell 
program to include or remove someone from excluded people list.

To run the game download all files in your computer, using a terminal type:

lua fortune_weel.lua
