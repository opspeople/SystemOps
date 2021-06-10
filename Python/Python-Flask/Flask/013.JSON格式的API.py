# JSON 格式的响应是常见的，用 Flask 写这样的 API 是很容易上手的。
# 如果从视图 返回一个 dict ，那么它会被转换为一个 JSON 响应。
@app.route("/me")
def me_api():
    user = get_current_user()
    return {
        "username": user.username,
        "theme": user.theme,
        "image": url_for("user_image", filename=user.image),
    }

# 如果 dict 还不能满足需求，还需要创建其他类型的 JSON 格式响应，可以使用 jsonify() 函数。
# 该函数会序列化任何支持的 JSON 数据类型。
# 也可以研究研究 Flask 社区扩展，以支持更复杂的应用。
@app.route("/users")
def users_api():
    users = get_all_users()
    return jsonify([user.to_json() for user in users])

