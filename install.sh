echo "----- Purge docker dist -----"
rm -rf ./docker/dist
echo "----- Purge frontend dist -----"
rm -rf ./frontend/dist
cd frontend/
echo "----- Generate frontend assets -----"
npm run generate
cd ../docker
cp -R ../frontend/dist .
echo "----- Build docker image -----"
docker build -t mynuxt-app .
cd ../
echo "----- Install chart helm -----"
helm install nuxt ./helm
echo "----- Start pod -----"
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=helm,app.kubernetes.io/instance=nuxt" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
sleep 10 && kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT