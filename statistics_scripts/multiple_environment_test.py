#!/usr/bin/env python
import rospy
from std_msgs.msg import String
from std_msgs.msg import Bool
from std_msgs.msg import Float64
from std_srvs.srv import Trigger

import time

def rosloop():
    bug_name = 'gradient_bug'
    noise_level = 0.2
    amount_of_environment = 5
    rospy.wait_for_service('/indoor_gen')
    indoor_gen_srv = rospy.ServiceProxy('/indoor_gen',Trigger)
    environment_random_pub = rospy.Publisher('/random_environment', Bool, queue_size=10)
    noise_level_pub = rospy.Publisher('/noise_level', Float64, queue_size=10)
    switch_bug_pub = rospy.Publisher('/switch_bug',String, queue_size=10)
    
    
    for it in range (1,amount_of_environment):
        indoor_gen_srv()
        
        time.sleep(1)
        
        msg = Bool()
        msg = True
        
        environment_random_pub.publish(msg)




if __name__ == '__main__':

    time.sleep(2)
    rospy.init_node("experiment_script")
    #rospy.wait_for_service('get_vel_cmd')
    try:
        rosloop()
    except rospy.ROSInterruptException:
        pass