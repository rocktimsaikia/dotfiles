#!/usr/bin/env node

import { exec } from 'child_process';

console.log('Updating claude-code...');

exec('npm i -g @anthropic-ai/claude-code', (error, stdout, stderr) => {
    if (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }

    if (stderr) {
        console.log(stderr);
    }

    if (stdout) {
        console.log(stdout);
    }

    console.log('Update completed');
    process.exit(0);
});
