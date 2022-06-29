import sys

# Read terminfo from stdin
features = {}
idx = 0
for line in sys.stdin.readlines():
    if line.startswith('#'):
        continue
    if idx == 0:
        header = line
    else:
        features.update({
            parts[0]: parts[2] for parts in (
                s.strip().partition('=')
                for s in line.split(',')
            )
        })
    idx += 1

# Transform the terminfo
if 'sgr' in features:
    features['sgr'] = features['sgr'].replace('%?%p1%t;3%', '%?%p1%t;7%')
features['sitm'] = r'\E[3m'
features['ritm'] = r'\E[23m'
features['smso'] = r'\E[7m'
features['rmso'] = r'\E[27m'

# Write terminfo to stdout
sys.stdout.write(header)
for idx, (k, v) in enumerate(features.items()):
    if not k.strip():
        continue
    sys.stdout.write('\t')
    if v:
        sys.stdout.write(k)
        sys.stdout.write('=')
        sys.stdout.write(v)
    else:
        sys.stdout.write(k)
    sys.stdout.write(',')
    sys.stdout.write('\n')
