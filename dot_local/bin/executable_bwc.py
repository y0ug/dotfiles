#!/usr/bin/env python3
import json
import subprocess
import argparse
import sys
import os

def get_items():
    try:
        return json.loads(subprocess.check_output(['bw', 'list', 'items']).decode())
    except subprocess.CalledProcessError:
        print("Error: Failed to get items from Bitwarden", file=sys.stderr)
        sys.exit(1)

def get_item_value(item, field):
    # Handle login fields
    if 'login' in item and item['login']:
        if field == 'username':
            return item['login'].get('username', '')
        elif field == 'password':
            return item['login'].get('password', '')
        elif field == 'otp' and item['login'].get('totp'):
            try:
                return subprocess.check_output(['bw', 'get', 'totp', item['id']]).decode().strip()
            except subprocess.CalledProcessError:
                return ''
    
    # Handle custom fields
    if 'fields' in item and item['fields']:
        for custom_field in item['fields']:
            if custom_field['name'].lower() == field.lower():
                return custom_field['value']
    
    # Handle basic fields
    if field == 'id':
        return item['id']
    elif field == 'name':
        return item['name']
    
    return ''

def list_items(items, format_string=None):
    if format_string:
        for item in items:
            try:
                # Get basic item info
                data = {
                    'name': item['name'],
                    'id': item['id'],
                    'type': 'login' if 'login' in item and item['login'] else 'note'
                }
                
                # Add login fields if they exist
                if 'login' in item and item['login']:
                    data['username'] = item['login'].get('username', '')
                
                # Add custom fields
                if 'fields' in item and item['fields']:
                    for field in item['fields']:
                        data[field['name'].lower()] = field['value']
                
                print(format_string.format(**data))
            except KeyError as e:
                print(f"Invalid format key: {e}", file=sys.stderr)
                sys.exit(1)
    else:
        # Default format: name<tab>type<tab>id
        for item in items:
            item_type = 'login' if 'login' in item and item['login'] else 'note'
            item_username = ""
            if item_type == 'login':
                item_username = item['login'].get('username', '')
            print(item_to_string(item))

def item_to_string(item):
    item_type = 'login' if 'login' in item and item['login'] else 'note'
    item_username = ""
    if item_type == 'login':
        item_username = item['login'].get('username', '')
    return f"{item['name']}\t{item_type}\t{item_username}\t{item['id']}"

def select_with_fuzzel(items):
    items_str = '\n'.join(item_to_string(item)
                         for item in items)
    try:
        result = subprocess.run(['fuzzel', '--dmenu'], input=items_str.encode(), capture_output=True)
        if result.returncode == 0:
            return result.stdout.decode().strip().split('\t')[-1]  # Return the ID
    except FileNotFoundError:
        print("Error: fuzzel not found", file=sys.stderr)
        sys.exit(1)
    return None

def get_item_by_id(items, item_id):
    for item in items:
        if item['id'] == item_id:
            return item
    return None

def main():
    parser = argparse.ArgumentParser(description='Bitwarden credential fetcher')
    parser.add_argument('search', nargs='?', help='Search term for credential')
    parser.add_argument('--fields', help='Comma-separated list of fields to return')
    parser.add_argument('--list', action='store_true', help='List all items')
    parser.add_argument('--select', action='store_true', help='Use fuzzel to select an item')
    parser.add_argument('--format', help='Custom format for listing (e.g., "{name}\t{type}")')
    
    args = parser.parse_args()
    
    items = get_items()
    
    if args.list:
        list_items(items, args.format)
        sys.exit(0)
    
    if args.select:
        selected_id = select_with_fuzzel(items)
        if not selected_id:
            sys.exit(1)
        item = get_item_by_id(items, selected_id)
    else:
        if not args.search:
            print("Error: either --select or search term is required", file=sys.stderr)
            sys.exit(1)
        matches = [item for item in items if args.search.lower() in item['name'].lower()]
        if not matches:
            print(f"No matches found for '{args.search}'", file=sys.stderr)
            sys.exit(1)
        item = matches[0]
    
    fields = args.fields.split(',') if args.fields else ['id']
    result = {field: get_item_value(item, field) for field in fields}
    
    if len(fields) == 1:
        print(result[fields[0]])
    else:
        for key, value in result.items():
            print(f"export BW_{key.upper()}='{value}'")

if __name__ == '__main__':
    main()
