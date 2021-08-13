like = None
id_ = None
with open("/etc/os-release", "r") as f:
    for line in map(lambda l: l.strip(), f):
        if line.startswith("ID_LIKE="):
            if "rhel" in line:
                like = "rhel"
            elif "debian" in line:
                like = "debian"
        if line.startswith("ID="):
            id_ = line.partition("=")[2]
if like is not None:
    print(like)
else:
    print(id_)