(clear-all)

(define-model unit2

(sgp :v t :show-focus t :trace-detail high)


(chunk-type read-letters state)
(chunk-type array letter1 letter2 letter3)

;定义缓冲区
(add-dm
;先定义一些slot，这些是state的具体情况的名词
 (start isa chunk)
 (start2 isa chunk)
 (start3 isa chunk)
 (attend isa chunk)
 (attend2 isa chunk)
 (attend3 isa chunk)
 (respond isa chunk)
 (done isa chunk)
;goal的陈述句式
 (goal isa read-letters state start))

;产生式
;如果任务开始，清理attended缓冲
 (P find-unattended-letter
    =goal>
       ISA         read-letters
       state       start
  ==>
    +visual-location>
       :attended    nil
    =goal>
       state       find-location
 )
 ;把注意移动到视野中
 (P attend-letter
    =goal>
       ISA         read-letters
       state       find-location
    =visual-location>
    ?visual>
       state       free
 ==>
    +visual>
       cmd         move-attention
       screen-pos  =visual-location
    =goal>
       state       attend
 )
 ;先读第一个字母，识别内容，怎么做到的？咋就知道是字母呢？读完以后把目标设置为读letter2
  (P encode-letter1
     =goal>
        ISA         read-letters
        state       attend
     =visual>
        value       =letter1
     ?imaginal>
        state       free
  ==>
     =goal>
        state       start2
     +imaginal>
        isa         array
        letter1      =letter1
  )

;开始第2个，注意力集中了
  (P find-unattended-letter2
     =goal>
        ISA         read-letters
        state       start2
   ==>
     +visual-location>
        :attended    nil
     =goal>
        state       find-location2
  )
  ;把注意移动到视野中
  (P attend-letter2
     =goal>
        ISA         read-letters
        state       find-location2
     =visual-location>
     ?visual>
        state       free
  ==>
     +visual>
        cmd         move-attention
        screen-pos  =visual-location
     =goal>
        state       attend2
  )

;先读第一个字母，识别内容，怎么做到的？咋就知道是字母呢？读完以后把目标设置为读letter2
 (P encode-letter2
    =goal>
       ISA         read-letters
       state       attend2
    =visual>
       value       =letter2
    ?imaginal>
       state       free
 ==>
    =goal>
       state       start3
    +imaginal>
       isa         array
       letter2     =letter2
 )

 ;开始第3个，注意力再次集中了
   (P find-unattended-letter3
      =goal>
         ISA         read-letters
         state       start3
    ==>
      +visual-location>
         :attended    nil
      =goal>
         state       find-location3
   )
   ;把注意移动到视野中
   (P attend-letter3
      =goal>
         ISA         read-letters
         state       find-location3
      =visual-location>
      ?visual>
         state       free
   ==>
      +visual>
         cmd         move-attention
         screen-pos  =visual-location
      =goal>
         state       attend3
   )
 ;再读第2个字母，似乎是自动识别。读完把目标设置为respond
  (P encode-letter3
     =goal>
        ISA         read-letters
        state       attend3
     =visual>
        value       =letter3
     ?imaginal>
        state       free
  ==>
     =goal>
        state       respond
     +imaginal>
        isa         array
        letter3      =letter3
  )

 ;反馈，行动模块输出按键指令，参数是识别到的字母
 (P respond
    =goal>
       ISA         read-letters
       state       respond
    =imaginal>
       isa         array
       letter3      =letter3
    ?manual>
       state       free
 ==>
    =goal>
       state       done
    +manual>
       cmd         press-key
       key         =letter3
 )


;聚焦目标，干活
(goal-focus goal)
)
