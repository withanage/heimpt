__author__ = "Dulip Withanage"

class Settings:
    def __init__(self,args):
        self.args = args

    def get_setting(self, tag_name, caller, domain=None):
        return tag_name