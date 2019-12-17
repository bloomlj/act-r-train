# encoding: utf-8

import actr
actr.load_act_r_model("ACT-R:act-r-train;unit2-assignment-model.lisp")
response = False


def respond_to_key_press (model,key):
    global response

    response = key

def exp (human=False):

    actr.reset()

    #测试可以识别数字

    # items = actr.permute_list(["1","2","3","4","5","6","7","8","9",
    #                            "10","11","12","13","14","15","16","17","18",
    #                            "19","20","21"])

    items = actr.permute_list(["B","C","D","F","G","H","J","K","L",
                               "M","N","P","Q","R","S","T","V","W",
                               "X","Y","Z"])

    target = items[0]
    foil = items[1]
    window = actr.open_exp_window("Letter difference")
    text1 = foil
    text2 = foil
    text3 = foil
    index = actr.random(3)

    #random number inner 3

    if index == 0:
       text1 = target
    elif index == 1:
       text2 = target
    else:
       text3 = target

    #add letter to windows
    actr.add_text_to_exp_window(window, text1, x=125, y=75)
    actr.add_text_to_exp_window(window, text2, x=75, y=175)
    actr.add_text_to_exp_window(window, text3, x=175, y=175)

    #why here bind the respond_to_key_press function to monitor 's out-key function'
    actr.add_command("unit2-key-press",respond_to_key_press,
                      "Assignment 2 task output-key monitor")
    actr.monitor_command("output-key","unit2-key-press")

    global response
    response = ''

    if human == True:
        while response == '':
            actr.process_events()

    else:
        actr.install_device(window) #add the windows as a device for act-r model(the machine brain)
        actr.run(10,True)

    actr.remove_command_monitor("output-key","unit2-key-press")
    actr.remove_command ("unit2-key-press")

    if response.lower() == target.lower():
        return True
    else:
        return False
