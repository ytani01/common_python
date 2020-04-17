#!/usr/bin/env python3
#
# (c) 2019 Yoichi Tanibayashi
#

import click

from logging import getLogger, StreamHandler, Formatter, DEBUG, INFO, WARN
logger = getLogger(__name__)
logger.setLevel(INFO)
handler = StreamHandler()
handler.setLevel(DEBUG)
handler_fmt = Formatter(
    '%(asctime)s %(levelname)s %(name)s.%(funcName)s> %(message)s',
    datefmt='%H:%M:%S')
handler.setFormatter(handler_fmt)
logger.addHandler(handler)
logger.propagate = False
def init_logger(name, debug):
    l = logger.getChild(name)
    if debug:
        l.setLevel(DEBUG)
    else:
        l.setLevel(INFO)
    return l

#####
class TemplateClass:
    def __init__(self, arg1, debug=False):
        self.logger = init_logger(__class__.__name__, debug)
        self.debug = debug
        self.logger.debug('arg1 = %s', arg1)

        self.arg1 = arg1

    def __enter__(self):
        self.logger.debug('enter \'with\' block')
        return self.open()	# return 'self'

    def __exit__(self, ex_type, ex_value, trace):
        self.logger.debug('(%s,%s,%s)', ex_type, ex_value, trace)
        self.close()
        self.logger.debug('exit \'with\' block')

    def open(self):
        self.logger.debug('')

        return self	# if ok return 'self'

    def close(self):
        self.logger.debug('')

##### sample application
class Sample:
    def __init__(self, arg1, debug=False):
        self.logger = init_logger(__class__.__name__, debug)
        self.debug = debug
        self.logger.debug('arg1 = %s', arg1)

        self.arg1 = arg1

    def main(self):
        self.logger.debug('')

        with TemplateClass(self.arg1, debug=self.debug) as a:
            print('a = %s' % a)

    def finish(self):
        self.logger.debug('')

#####
CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])
@click.command(context_settings=CONTEXT_SETTINGS)
@click.argument('arg1', metavar='<arg1>', type=str, default='abc', nargs=1)
@click.option('--debug', '-d', 'debug', is_flag=True, default=False,
              help='debug flag')
def main(arg1, debug):
    logger = init_logger('', debug)
    logger.debug('arg1  = %s', arg1)
    logger.debug('debug = %s', debug)

    try:
        obj = Sample(arg1, debug=debug)
        obj.main()
    finally:
        obj.finish()

if __name__ == '__main__':
    main()
