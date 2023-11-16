import re
import sys
import ast

# Check if at least one command-line argument is provided
if len(sys.argv) < 2:
    print("Usage: python my_script.py <arg1> [arg2] [arg3] ...")
    sys.exit(1)

arg1=sys.argv[1]
arg2=sys.argv[2]
f_user=sys.argv[3]
pf=sys.argv[4]

host_alias=ast.literal_eval(arg1)
server_config=ast.literal_eval(arg2)
cnt=0

for line in host_alias:
    cnt=cnt+1
    columns = line.split(' ')
    server = columns[0]
    ip = columns[1]
    pem_file = list(filter(lambda l: l.startswith(server + '_private_key:'), server_config))[0].split(': ')[1] if not pf else pf
    sub_systems = list(filter(lambda l: l.startswith(server + '_config:'), server_config))[0].split(': ')[1].split(',')
    a360_flag = 0;

    print("    server" + str(cnt) + ":" )
    print("      ansible_host: "+ip)
    print("      ansible_ssh_private_key_file: "+pem_file)
    print("      ansible_user: "+f_user)

    if "eme" in sub_systems:
        print("    eme:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "control" in sub_systems:
        print("    control:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "ag" in sub_systems:
        print("    ag:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "cafe" in sub_systems:
        print("    cafe:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "cc" in sub_systems:
        print("    cc:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "queryit" in sub_systems:
        print("    queryit:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

    if "cipui" in sub_systems:
        print("    cipui:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)
        
    if "a360" in sub_systems:
        print("    a360:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)
        a360_flag = 1

    if "nbos_control" in sub_systems:
        print("    nbos_control:")
        print("      ansible_host: "+ip)
        print("      ansible_ssh_private_key_file: "+pem_file)
        print("      ansible_user: "+f_user)

if a360_flag == 0:
    print("    a360:")
    print("      ansible_host: null")
    print("      ansible_ssh_private_key_file: "+pem_file)
    print("      ansible_user: "+f_user)
    
