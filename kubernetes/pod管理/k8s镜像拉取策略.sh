1.总是拉取
	Always
	imagePullPolicy: Always
2.默认值，本地有则使用本地镜像，不拉取
	imagePullPolicy: IfNotPresent
3.只使用本地镜像，从不拉取
	imagePullPolicy: Never
	