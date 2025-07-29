module.exports = {
    apps: [{
        name: 'claude-updater',
        script: 'update-claude.js',
        cron_restart: '*/15 * * * *', // Every 15 minutes
        autorestart: false
    }]
};
