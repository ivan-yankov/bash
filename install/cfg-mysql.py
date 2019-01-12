import os

with open('/etc/mysql/my.cnf', 'a') as cnf:
    cnf.write('\n[mysqld]')
    cnf.write('\ncharacter_set_client=utf8')
    cnf.write('\ncharacter_set_server=utf8')
    cnf.write('\ncollation_server=utf8_unicode_ci')
    cnf.write('\nmax_allowed_packet=1000M')
    cnf.close()
