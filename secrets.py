#!/usr/bin/env python3
import sys
import os
import argparse
import subprocess

dotfiles_folder = os.path.dirname(os.path.realpath(__file__))
os.chdir(dotfiles_folder)

secrets_folder = os.path.join(dotfiles_folder, 'secrets')
secrets_file = os.path.join(dotfiles_folder, 'secrets.tgz.gpg')

class SecretManager():
    def __init__(self):
        cmds = [ c  for c in dir(self) if not c.startswith('_')]
        parser = argparse.ArgumentParser(
            prog = 'Manage my dotfiles secrets')
        parser.add_argument('command', help='Subcommand to run', choices=cmds)

        self.secret_key = os.environ.get("DOTFILES_SECRET", None)
        if self.secret_key == None:
            raise Exception("environement variable DOTFILES_SECRET need to be set")

        args = parser.parse_args(sys.argv[1:2])
        getattr(self, args.command)()

    def encrypt(self):
        cmd = f'tar  -czvf - {os.path.relpath(secrets_folder)} | gpg --symmetric --passphrase "{self.secret_key}" --pinentry-mode loopback --cipher-algo AES256 - > {secrets_file}'
        ps = subprocess.Popen(cmd, shell=True)
        ps.communicate()

    def decrypt(self):
        if not os.path.exists(secrets_file):
            raise Exception(f"file {secrets_file} does not exist")

        cmd = f'gpg --decrypt --passphrase "{self.secret_key}" --pinentry-mode loopback  --cipher-algo AES256 {secrets_file} | tar  -xzvf -'
        ps = subprocess.Popen(cmd, shell=True)
        ps.communicate()


if __name__ == "__main__":
    SecretManager()



