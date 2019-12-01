function Stop($composeFile)
{
	docker-compose -f $composeFile down

}


Stop "docker-compose.9.3.0.xp.yml"




