import abc


class Import(object, metaclass=abc.ABCMeta):
    @abc.abstractmethod
    def run(self):
        raise NotImplementedError(
            'Method run() not implemented')


