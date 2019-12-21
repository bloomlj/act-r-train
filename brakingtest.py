# encoding: utf-8

import actr

actr.load_act_r_model("ACT-R:act-r-train;brakingtest.lisp")

response = False

def respond_to_key_press (model,key):
    global response

    response = key
    print(response)
    actr.clear_exp_window()


def exp (human=False):

    actr.reset()

    #items = actr.permute_list(["A","B","C","D","0","E","F","G","H"])
    items = ["P7","P6","C","D","0","E","F","G","H"]

    #text1 = items[1]
    for text in items:
        #从测试来看，中文不行啊。
        cmd = "请将手柄移动至"+text+ "位。"
        #cmd = text
        window = actr.open_exp_window("Braking Test Experiment CRH380D")
        actr.add_text_to_exp_window(window, cmd, x=100, y=150)
        actr.add_command("brakingtest-key-press",respond_to_key_press,
                         "Brakingtest task output-key monitor")
        actr.monitor_command("output-key","brakingtest-key-press")
        global response
        response = False

        if human == True:
            while response == False:
                actr.process_events()

        else:
            actr.install_device(window)
            actr.run(10,True)

        actr.remove_command_monitor("output-key","brakingtest-key-press")
        actr.remove_command("brakingtest-key-press")

    return response
