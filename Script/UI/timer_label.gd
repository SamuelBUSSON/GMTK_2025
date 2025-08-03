extends Label

func _process(delta):
    self.text = "Time left : %02d seconds" % GameGlobal.duration
    pass