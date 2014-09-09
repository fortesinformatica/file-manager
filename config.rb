file_managers = {
    xml_data: {
        type: 'local',
        root_path:'reports/'
    },
    jasper: {
        type: 'local',
        root_path:'reports/'
    },
    pdf: {
        type: 'local',
        root_path:'reports/'
    },
    txt: {
        type: 'S3',
        access_key_id: 'your key',
        secret_access_key: 'your access',
        bucket: 'your bucket'
    }
}
