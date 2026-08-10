from supabase import create_client

# Asenda siin jutumärkide sees olevad andmed enda omadega:
url = "https://dtsydmqdwcpwebksxnkw.supabase.co"
key = "sb_publishable_AOKFWVuhQzk4IrvNUzz1-g_qXZJiwmU"

supabase = create_client(url, key)

# Asenda 'team_members' selle tabeli nimega, mis sul Supabase'is olemas on:
response = supabase.table('team_members').select("*").execute()

print(f"Leitud ridu: {len(response.data)}")
for row in response.data:
    print(row)