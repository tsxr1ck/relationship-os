import { forwardRef, InputHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, label, id, ...props }, ref) => {
    return (
      <div className="flex flex-col gap-1.5 w-full">
        {label && (
          <label 
            htmlFor={id} 
            className="text-xs font-bold uppercase tracking-wider pl-1"
            style={{ color: 'var(--color-text-secondary)' }}
          >
            {label}
          </label>
        )}
        <input
          type={type}
          id={id}
          className={cn(
            'flex h-11 w-full rounded-xl px-4 py-2 text-sm transition-all duration-200',
            'placeholder:text-text-tertiary',
            'focus:outline-none focus:ring-1 focus:ring-primary/30',
            'disabled:cursor-not-allowed disabled:opacity-50 overflow-hidden',
            className
          )}
          style={{
            background: 'var(--color-surface-3)',
            color: 'var(--color-text-primary)',
            border: '1px solid var(--color-border)',
          }}
          ref={ref}
          {...props}
        />
      </div>
    );
  }
);

Input.displayName = 'Input';

export { Input };
