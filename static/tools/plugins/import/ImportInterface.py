import abc


class Import(object):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def run(self):
        raise NotImplementedError(
            'Method run() not implemented')


