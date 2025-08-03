extends Label

func _process(delta):
    self.text = "Time left : %02ds" % GameGlobal.duration
    pass